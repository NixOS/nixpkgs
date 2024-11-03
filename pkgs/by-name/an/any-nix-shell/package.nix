{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  gnused,
  which,
}:

stdenv.mkDerivation rec {
  pname = "any-nix-shell";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "haslersn";
    repo = "any-nix-shell";
    rev = "v${version}";
    hash = "sha256-t6+LKSGWmkHQhfqw/4Ztz4QgDXQ2RZr9R/mMEEA3jlY=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bash ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r bin $out
    wrapProgram $out/bin/any-nix-shell --prefix PATH ":" ${
      lib.makeBinPath [
        (placeholder "out")
        gnused
        which
      ]
    }

    runHook postInstall
  '';

  meta = {
    description = "fish, xonsh and zsh support for nix-shell";
    license = lib.licenses.mit;
    homepage = "https://github.com/haslersn/any-nix-shell";
    maintainers = with lib.maintainers; [ haslersn ];
    mainProgram = "any-nix-shell";
  };
}
