#include <dlfcn.h>

__attribute__((constructor))
static void preload_mkl()
{
    // MKL libs must be loaded with RTLD_GLOBAL (see comments in mkl-service)
    // Without forcing it here, things fail at runtime when mkl_core tries to
    // dlopen libmkl_avx512, etc.
    dlopen("libmkl_core.so",       RTLD_LAZY | RTLD_GLOBAL);
    dlopen("libmkl_gnu_thread.so", RTLD_LAZY | RTLD_GLOBAL);
    dlopen("libmkl_intel_lp64.so", RTLD_LAZY | RTLD_GLOBAL);
}

// mkl-service, possibly others link against these, give it something to call

void MKL_Set_Threading_Layer()
{
    // computer says no
}

void MKL_Set_Interface_Layer()
{
    // computer says no
}
