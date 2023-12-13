{ lib
, rustPlatform
, installShellFiles
, makeWrapper
, fetchFromGitHub
, nvd
, use-nom ? true
, nix-output-monitor ? null
}:

assert use-nom -> nix-output-monitor != null;

let
  version = "3.4.12";
  runtimeDeps = [ nvd ] ++ lib.optionals use-nom [ nix-output-monitor ];
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "nh";

  src = fetchFromGitHub {
    owner = "ViperML";
    repo = "nh";
    rev = "refs/tags/v${version}";
    hash = "sha256-V5TQ/1loQnegDjfLh61DxBWEQZivYEBq2kQpT0fn2cQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

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

  cargoHash = "sha256-Ul4DM8WmKvKG32zBXzpdzHZknpTQAVvrxFcEd/C1buA=";

  meta = {
    description = "Yet another nix cli helper";
    homepage = "https://github.com/ViperML/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [ drupol viperML ];
  };
}
