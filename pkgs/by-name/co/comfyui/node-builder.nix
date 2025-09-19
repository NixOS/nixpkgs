{
  lib,
  pythonPackages,
  stdenvNoCC,

  bandit,
}:
{
  pname,
  banditSkipChecks ? [],
  ...
}@attrs:
stdenvNoCC.mkDerivation (oa: attrs // {
  pname = "comfyui-node-${pname}";

  dontBuild = true;

  nativeCheckInputs = [
    bandit
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    bandit -r . ${lib.optionalString (banditSkipChecks != []) "-s ${lib.concatStringsSep "," banditSkipChecks}"}

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${pythonPackages.python.sitePackages}/custom_nodes/
    cd ..
    mv ${oa.src.name} $out/${pythonPackages.python.sitePackages}/custom_nodes/${pname}

    runHook postInstall
  '';
})
