with (import <nixpkgs> { }).forceSystem "x86_64-linux" "x86_64";

hello.overrideDerivation (x: {
  name = "hello-${toString builtins.currentTime}";
})
