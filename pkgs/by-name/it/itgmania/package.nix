{
  symlinkJoin,
  makeWrapper,
  itgmaniaPackages,
  extraPackages ? [ ],
}:
let
  unwrapped = itgmaniaPackages.itgmania-unwrapped;
in
symlinkJoin {
  inherit (unwrapped) pname version meta;

  paths = [ unwrapped ] ++ extraPackages;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    makeWrapper $out/itgmania/itgmania $out/bin/itgmania \
      --chdir $out/itgmania
  '';

  passthru.unwrapped = unwrapped;
}
