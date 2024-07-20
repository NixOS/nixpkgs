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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "haslersn";
    repo = "any-nix-shell";
    rev = "v${version}";
    hash = "sha256-n4+aokW5o3EuXKqyc12vRsn5Mlkvdso27AdpahhySYw=";
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
