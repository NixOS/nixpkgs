{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "eslint";
<<<<<<< HEAD
  version = "9.39.2";
=======
  version = "9.39.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VIJLEMIg9WUbrSAAHCZ6AJRrao0ssSbR+fyFQE+56vY=";
=======
    hash = "sha256-++79Xcjbew56sglX9IMwLDNmbBeHzW1+yvt51ID9/4s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # NOTE: Generating lock-file
  # arch = [ x64 arm64 ]
  # platform = [ darwin linux]
  # npm install --package-lock-only --arch=<arch> --platform=<os>
  # darwin seems to generate a cross platform compatible lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

<<<<<<< HEAD
  npmDepsHash = "sha256-5QC0XLxcwawRcrc3r3EfFdo3hTZDTHz9BF68WJLk7SE=";
=======
  npmDepsHash = "sha256-ImYxBeVgfkTxU2tvSCWgWgpECsIkGiXWrx+RZKwwYxY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  npmInstallFlags = [ "--omit=dev" ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mdaniels5757
      onny
    ];
  };
}
