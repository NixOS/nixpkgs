{ stdenv, lib, fetchFromGitHub, buildBazelPackage, buildPackages, nix-update-script }:
buildBazelPackage rec {
  name = "protoc-gen-js";
  version = "3.21.2";
  inherit (buildPackages) bazel;
  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-javascript";
    rev = "v${version}";
    hash = "sha256-TmP6xftUVTD7yML7UEM/DB8bcsL5RFlKPyCpcboD86U=";
  };
  bazelTargets = [ "plugin_files" ];
  removeRulesCC = false;
  fetchAttrs.sha256 = "sha256-H0zTMCMFct09WdR/mzcs9FcC2OU/ZhGye7GAkx4tGa8=";
  buildAttrs = {
    installPhase = ''
      mkdir -p $out/bin
      cp bazel-bin/generator/protoc-gen-js $out/bin
    '';
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Protobuf JavaScript code generator";
    homepage = "https://github.com/protocolbuffers/protobuf-javascript";
    license = licenses.bsd3;
    maintainers = with maintainers; [ squalus ];
    mainProgram = "protoc-gen-js";
  };
}
