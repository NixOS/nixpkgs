{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  git,
  coreutils,
  gnused,
  gnugrep,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "git-fixup";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "keis";
    repo = "git-fixup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Mue2xgYxJSEu0VoDmB7rnoSuzyT038xzETUO1fwptrs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  installFlags = [
    "install"
    "install-fish"
    "install-zsh"
  ];

  postInstall = ''
    wrapProgram $out/bin/git-fixup \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          coreutils
          gnused
          gnugrep
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Fighting the copy-paste element of your rebase workflow";
    homepage = "https://github.com/keis/git-fixup";
    license = licenses.isc;
    maintainers = with maintainers; [ michaeladler ];
    platforms = platforms.all;
    mainProgram = "git-fixup";
  };
})
