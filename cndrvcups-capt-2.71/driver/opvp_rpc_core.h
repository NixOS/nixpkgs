/*

Copyright (c) 2003-2004, AXE, Inc.  All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
/*
   2007 Modified  for OPVP 1.0 by BBR Inc.
*/
#ifndef _OPVP_RPC_CORE_H_
#define _OPVP_RPC_CORE_H_

#include <string.h>

extern void *oprpc_init(int inFd, int outFd);
extern int oprpc_flush(void *ap);
extern int oprpc_destroy(void *ap);
extern int oprpc_putPkt(void *ap, const char *buf, int len);
extern int oprpc_putPktPointer(void *ap, const void *p, int len);
extern int oprpc_putPktStart(void *ap, int seqNo, int reqNo);
extern int oprpc_putPktStartNonBlock(void *ap, int seqNo, int reqNo);
extern int oprpc_putPktEnd(void *ap);
extern int oprpc_getPkt(void *ap, char *buf, int len);
extern int oprpc_getPktPointer(void *ap, void **p, int len);
extern int oprpc_getPktStart(void *ap);
extern int oprpc_getPktStartNonBlock(void *ap);
extern int oprpc_getPktEnd(void *ap);
extern int oprpc_getStr(void *ap, void **str);
extern int oprpc_addInPktIndex(void *ap, int len);

extern int oprpc_putError(void *ap, int seqNo, int eNo, int reqNo);

#define oprpc_put(ap,v) oprpc_putPkt((ap),(const char *)(&v),sizeof(v))
#define oprpc_putType(ap,vp,type) oprpc_putPkt((ap),\
    (const char *)(vp),sizeof(type))
#define oprpc_putInt(ap,vp) oprpc_putType(ap,vp,int)
#define oprpc_putStr(ap,s) oprpc_putPktPointer((ap),(s),\
  (s) != NULL ? strlen((char *)s)+1: 0)

#define oprpc_get(ap,v) oprpc_getPkt((ap),(char *)(&v),sizeof(v))
#define oprpc_getType(ap,vp,type) oprpc_getPkt((ap),(char *)(vp),sizeof(type))
#define oprpc_getInt(ap,vp) oprpc_getType(ap,vp,int)

#endif
