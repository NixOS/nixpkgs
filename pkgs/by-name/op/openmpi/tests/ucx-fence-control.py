"""Generate a lifecycle fixture from the patched OpenMPI source in cwd.

This is a source-level lifecycle regression, not an MPI/UCX transport test.
"""
from pathlib import Path
source = Path.cwd()
c = (source / "opal/mca/common/ucx/common_ucx.c").read_text()
h = (source / "opal/mca/common/ucx/common_ucx.h").read_text()
internal = (source / "opal/mca/pmix/pmix-internal.h").read_text()
def function(text,name):
 start=text.rfind('\n',0,text.index(name))+1
 brace=text.index('{',text.index(name));depth=1;i=brace+1
 while depth:
  depth += (text[i]=='{')-(text[i]=='}');i+=1
 return text[start:i]+'\n'
def macro(name):
 lines=internal.splitlines();i=next(i for i,x in enumerate(lines) if x.startswith('#define '+name));out=[]
 while True:
  out.append(lines[i]);i+=1
  if not out[-1].endswith('\\'):break
 return '\n'.join(out)+'\n'
start=internal.index('typedef struct {',internal.index('typedef opal_cond_t'));end=internal.index('} opal_pmix_lock_t;',start)+len('} opal_pmix_lock_t;')
parts=[internal[start:end],macro('OPAL_PMIX_CONSTRUCT_LOCK'),macro('OPAL_PMIX_DESTRUCT_LOCK'),macro('OPAL_PMIX_WAKEUP_THREAD'),function(h,'opal_common_ucx_mca_pmix_fence_completed('),function(c,'opal_common_ucx_mca_fence_complete_cb('),function(c,'opal_common_ucx_mca_fence_lock_complete_cb('),function(c,'opal_common_ucx_mca_pmix_fence_start('),function(c,'opal_common_ucx_mca_pmix_fence_nb('),function(c,'opal_common_ucx_mca_pmix_fence_nb_lock('),function(c,'opal_common_ucx_mca_pmix_fence(ucp_worker_h')]
spml=(source/'oshmem/mca/spml/ucx/spml_ucx_component.c').read_text()
start=spml.index('    OPAL_PMIX_CONSTRUCT_LOCK(&fenced);');end=spml.index('    OPAL_PMIX_DESTRUCT_LOCK(&fenced);',start)+len('    OPAL_PMIX_DESTRUCT_LOCK(&fenced);');spml_wait=spml[start:end]
prefix=r'''#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#define OPAL_DECLSPEC
#define OPAL_SUCCESS 0
#define PMIX_SUCCESS 0
#define PMIX_OPERATION_SUCCEEDED 1
typedef void *ucp_worker_h;
typedef void (*pmix_op_cbfunc_t)(int,void *);
typedef pthread_mutex_t opal_mutex_t;
typedef pthread_cond_t opal_pmix_condition_t;
static int constructed,destructed;
#define OBJ_CONSTRUCT(p,t) do { assert(0==pthread_mutex_init(p,NULL));constructed++; } while(0)
#define OBJ_DESTRUCT(p) do { assert(0==pthread_mutex_destroy(p));destructed++; } while(0)
#define opal_cond_init(p) assert(0==pthread_cond_init(p,NULL))
#define opal_cond_destroy(p) assert(0==pthread_cond_destroy(p))
#define opal_mutex_lock(p) assert(0==pthread_mutex_lock(p))
#define opal_mutex_unlock(p) assert(0==pthread_mutex_unlock(p))
#define opal_pmix_condition_broadcast(p) assert(0==pthread_cond_broadcast(p))
#define OPAL_POST_OBJECT(p) atomic_thread_fence(memory_order_release)
#define OPAL_ACQUIRE_OBJECT(p) atomic_thread_fence(memory_order_acquire)
static struct { bool is_singleton; } opal_process_info;
static atomic_int progress_calls;
static int mode,submissions,callbacks;
static pthread_t thread;
static bool threaded;
static void (*scheduled)(int,void*);
static void *scheduled_data;
static void *complete_async(void *unused) {
 (void)unused;
 while(atomic_load_explicit(&progress_calls,memory_order_relaxed)<3) sched_yield();
 scheduled(mode==4?-77:0,scheduled_data); callbacks++;
 return NULL;
}
static int PMIx_Fence_nb(void *procs,size_t np,void *info,size_t ni,void (*cb)(int,void*),void *data) {
 (void)procs;(void)np;(void)info;(void)ni;submissions++;
 if(mode==1)return PMIX_OPERATION_SUCCEEDED;
 if(mode==2)return -9;
 if(mode==0||mode==5) {cb(mode==5?-77:0,data);callbacks++;return PMIX_SUCCESS;}
 scheduled=cb;scheduled_data=data;threaded=true;assert(0==pthread_create(&thread,NULL,complete_async,NULL));return PMIX_SUCCESS;
}
static int warnings;
#define SPML_UCX_WARN(...) do { warnings++; } while(0)
#define PMIx_Error_string(rc) "mock error"
static void progress(ucp_worker_h worker){(void)worker;atomic_fetch_add_explicit(&progress_calls,1,memory_order_relaxed);}
static void ucp_worker_progress(ucp_worker_h worker){progress(worker);}
struct mock_ctx { ucp_worker_h ucp_worker[1]; };
static struct mock_ctx ctx;
static struct mock_ctx *contexts[]={&ctx};
static struct { struct { int ctxs_count; struct mock_ctx **ctxs; } active_array,idle_array; unsigned ucp_workers;struct mock_ctx *aux_ctx;} mca_spml_ucx={{1,contexts},{1,contexts},1,&ctx};
static struct mock_ctx mca_spml_ucx_ctx_default;
#define MCA_COMMON_UCX_PROGRESS_LOOP(worker) for(;;progress(worker))
'''
suffix=r'''
static void run_nonblocking(void) {
 opal_pmix_lock_t fenced; int ret,i;
 EXACT_SPML_WAIT
}
static void run_legacy(void) {
 int flag=0;
 int ret=opal_common_ucx_mca_pmix_fence_nb(&flag);
 if(threaded) {atomic_store(&progress_calls,3);assert(0==pthread_join(thread,NULL));threaded=false;}
 assert(ret==(mode==2?-9:0));assert(flag==(mode==2?0:1));
}
int main(void) {
 alarm(20);
 int cases=0;
 for(int repetition=0;repetition<200;repetition++)for(int nonblocking=0;nonblocking<3;nonblocking++)for(mode=0;mode<7;mode++) {
  opal_process_info.is_singleton=mode==6;threaded=false;atomic_store(&progress_calls,0);submissions=callbacks=0;int before=constructed,after=destructed;
  if(nonblocking==2)run_legacy();
  else if(nonblocking)run_nonblocking();
  else {int ret=opal_common_ucx_mca_pmix_fence(NULL);assert(ret==(mode==2?-9:0));}
  if(threaded)assert(0==pthread_join(thread,NULL));
  assert(constructed-before==destructed-after);
  assert(submissions==(mode==6?0:1));
  assert(callbacks==((mode==0||mode==3||mode==4||mode==5)?1:0));
  if(mode==3||mode==4)assert(atomic_load(&progress_calls)>=3);
  cases++;
 }
 if(cases!=4200 || constructed!=2600 || destructed!=2600)return 1;
 printf("{\"passed\":true,\"cases\":%d,\"modes\":[\"callback-before-return\",\"immediate-success\",\"submission-error\",\"asynchronous-success\",\"asynchronous-error-preserved\",\"inline-error-preserved\",\"singleton\"],\"constructed\":%d,\"destructed\":%d}\n",cases,constructed,destructed);
}
'''
suffix=suffix.replace(' EXACT_SPML_WAIT',spml_wait)
parts.append('/* Exact OpenSHMEM wait fragment retained in test function. */')
print(prefix+'\n'.join(parts)+suffix)
