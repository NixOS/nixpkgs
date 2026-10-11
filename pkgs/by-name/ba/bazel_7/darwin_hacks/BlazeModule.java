package com.google.devtools.build.lib.runtime;

// We only need to capture enough details from Bazel source code
// to make our modules compile and be binary-compatible.
// This BlazeModule won't be injected into Bazel classpath.
public abstract class BlazeModule {
}
