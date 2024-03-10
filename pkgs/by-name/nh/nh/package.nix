{ stdenv
, lib
, rustPlatform
, installShellFiles
, makeBinaryWrapper
, darwin
, fetchFromGitHub
, nix-update-script
, nvd
, use-nom ? true
, nix-output-monitor ? null
}:

assert use-nom -> nix-output-monitor != null;

let
  version = "3.5.3";
  runtimeDeps = [ nvd ] ++ lib.optionals use-nom [ nix-output-monitor ];
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "nh";

  src = fetchFromGitHub {
    owner = "viperML";
    repo = "nh";
    rev = "refs/tags/v${version}";
    hash = "sha256-37BcFt67NZj4YQ9kqm69O+OJkgt+TXWTu53bvJvOtn8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  preFixup = ''
    mkdir completions
    $out/bin/nh completions --shell bash > completions/nh.bash
    $out/bin/nh completions --shell zsh > completions/nh.zsh
    $out/bin/nh completions --shell fish > completions/nh.fish

    installShellCompletion completions/*
  '';

  postFixup = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      ${lib.optionalString use-nom "--set-default NH_NOM 1"}
  '';

  cargoHash = "sha256-uRibycYznqzdf8QVX6bHfq3J3Imu8KnWCL0ZS1w4KFk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yet another nix cli helper";
    homepage = "https://github.com/viperML/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [ drupol viperML ];
  };
}
