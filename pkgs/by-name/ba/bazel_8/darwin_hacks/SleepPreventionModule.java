package com.google.devtools.build.lib.platform;

import com.google.devtools.build.lib.runtime.BlazeModule;

// This class can fail in Nix sandbox on Darwin so we replace
// it with a stub version
public final class SleepPreventionModule extends BlazeModule {
  // do nothing
}
