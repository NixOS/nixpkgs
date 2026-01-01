{
  lib,
  rdkafka,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
  fetchzip,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "parseable";
<<<<<<< HEAD
  version = "2.5.1";
=======
  version = "2.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "parseable";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+KTSpkrMlIu24YvHvLOLHZiqRZua3D7/kprFqtRuNOQ=";
=======
    hash = "sha256-0PyXrwFh2YroxeAPL2GCZiOUfzFLThN0ZnL0a7BDnfw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  LOCAL_ASSETS_PATH = fetchzip {
    url = "https://parseable-prism-build.s3.us-east-2.amazonaws.com/v${version}/build.zip";
<<<<<<< HEAD
    hash = "sha256-tSH9gyB9T2ywut+joLIp55Us2ALKvgsyiG/gBQgYLfI=";
  };

  cargoHash = "sha256-3hMGiQmXxar4n4cGPrj4UUznNi8V5YokH+29UGmz34Y=";
=======
    hash = "sha256-7uJvWAGDexzWhnm1ofPHzoRD8Q70fQ+eyUPpQHcWv4o=";
  };

  cargoHash = "sha256-VAdivS7zxoFrjeTnRGbUqtEgCj73iF29ZiCUfzdP1Yo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ rdkafka ];

  buildFeatures = [ "rdkafka/dynamic-linking" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Disk less, cloud native database for logs, observability, security, and compliance";
    homepage = "https://www.parseable.com";
    changelog = "https://github.com/parseablehq/parseable/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ilyakooo0 ];
    mainProgram = "parseable";
  };
}
