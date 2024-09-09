#ifndef NOESCAPE_NOOP_H_
#define NOESCAPE_NOOP_H_

// First, do some work to get definitions for *_WIDTH. Normally, Emacs would
// have these defined by headers in-tree, but clang's headers clash with those.
// Due to how include paths work, we have to include clang headers if we want to
// mess with CoreFoundation definitions.
#pragma push_macro("__STDC_VERSION__")
// Make the preprocessor think that we're on C2x. The macros we want are gated
// on it.
#undef __STDC_VERSION__
#define __STDC_VERSION__ 202000L
// Include limits.h first, as stdint.h includes it.
#include <limits.h>

// XX: clang's stdint.h is shy and won't give us its defs unless it thinks it's
// in freestanding mode.
#undef __STDC_HOSTED__
#include <stdint.h>
#define __STDC_HOSTED__ 1

#pragma pop_macro("__STDC_VERSION__")

// Now, pull in the header that defines CF_NOESCAPE.
#include <CoreFoundation/CFBase.h>

// Redefine CF_NOESCAPE as empty.
#undef CF_NOESCAPE
#define CF_NOESCAPE

#endif // NOESCAPE_NOOP_H_
