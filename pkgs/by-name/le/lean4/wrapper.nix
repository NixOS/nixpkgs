{
  symlinkJoin,
  makeWrapper,
  stdenv,
  lean4-unwrapped,
  variant ? "",
  extraPackages ? [ ],
  passthru ? { },
}:

symlinkJoin {
  name = "lean4${variant}-${lean4-unwrapped.version}";

  __structuredAttrs = true;
  strictDeps = true;

  paths = [
    lean4-unwrapped
  ]
  ++ extraPackages;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    if [[ -f $out/bin/olean-compare ]]; then
      # TODO: make this cleaner
      rm $out/bin/olean-compare
    fi

    wrapProgram $out/bin/lake \
      --set LAKE_OVERRIDE_LEAN 1 \
      --set LEAN_SYSROOT $out \
      --set-default LEAN_CC ${stdenv.cc}/bin/cc \
      --set-default LEAN_AR ${stdenv.cc.bintools.bintools}/bin/ar
  '';

  passthru = {
    unwrapped = lean4-unwrapped;
  }
  // passthru;

  inherit (lean4-unwrapped) meta;
}
