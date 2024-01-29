{ rustPlatform
, fetchFromGitHub
, lib

, makeWrapper
, installShellFiles
, stdenv
, Foundation

, withFile ? true
, file
, withJq ? true
, jq
, withPoppler ? true
, poppler_utils
, withUnar ? true
, unar
, withFfmpegthumbnailer ? true
, ffmpegthumbnailer
, withFd ? true
, fd
, withRipgrep ? true
, ripgrep
, withFzf ? true
, fzf
, withZoxide ? true
, zoxide

, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "yazi";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "sxyazi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XF5zCFXiViFsRPqI6p1Z7093NSWrGmcoyWcGEagIoEA=";
  };

  cargoHash = "sha256-9fXHpq5lXG9Gup1dZPlXiNilbP79fJ3Jp3+ZD7mAzP4=";

  env.YAZI_GEN_COMPLETIONS = true;

  nativeBuildInputs = [ makeWrapper installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

  postInstall = with lib;
    let
      runtimePaths = [ ]
        ++ optional withFile file
        ++ optional withJq jq
        ++ optional withPoppler poppler_utils
        ++ optional withUnar unar
        ++ optional withFfmpegthumbnailer ffmpegthumbnailer
        ++ optional withFd fd
        ++ optional withRipgrep ripgrep
        ++ optional withFzf fzf
        ++ optional withZoxide zoxide;
    in
    ''
      wrapProgram $out/bin/yazi \
         --prefix PATH : "${makeBinPath runtimePaths}"
      installShellCompletion --cmd yazi \
        --bash ./yazi-config/completions/yazi.bash \
        --fish ./yazi-config/completions/yazi.fish \
        --zsh  ./yazi-config/completions/_yazi
    '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Blazing fast terminal file manager written in Rust, based on async I/O";
    homepage = "https://github.com/sxyazi/yazi";
    license = licenses.mit;
    maintainers = with maintainers; [ xyenon matthiasbeyer ];
    mainProgram = "yazi";
  };
}
