{
  version,
  fetchzip,
  meta,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "resource-types";
  inherit version;
  src = fetchzip (
    (import ./sources.nix).${stdenv.hostPlatform.system}
      or (throw "concourse resource-types are not supported on ${stdenv.hostPlatform.system}")
  );
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    mv resource-types/* $out/
  '';

  meta = meta // {
    description = "Resource types for concourse worker";
  };
}
