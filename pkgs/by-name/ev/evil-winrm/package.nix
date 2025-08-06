{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bundlerEnv,
  bundlerUpdateScript,
}:
let
  rubyEnv = bundlerEnv {
    name = "evil-winrm";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
stdenv.mkDerivation rec {
  pname = "evil-winrm";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "Hackplayers";
    repo = "evil-winrm";
    tag = "v${version}";
    hash = "sha256-8Lyo7BgypzrHMEcbYlxo/XWwOtBqs2tczYnc3+XEbeA=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    rubyEnv.wrappedRuby
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp evil-winrm.rb $out/bin/evil-winrm
  '';

  passthru.updateScript = bundlerUpdateScript "evil-winrm";

  meta = {
    description = "WinRM shell for hacking/pentesting";
    mainProgram = "evil-winrm";
    homepage = "https://github.com/Hackplayers/evil-winrm";
    changelog = "https://github.com/Hackplayers/evil-winrm/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
  };
}
