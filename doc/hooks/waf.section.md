
### wafHook {#wafhook}

Overrides the configure, build, and install phases. This will run the “waf” script used by many projects. If `wafPath` (default `./waf`) doesn’t exist, it will copy the version of waf available in Nixpkgs. `wafFlags` can be used to pass flags to the waf script.
