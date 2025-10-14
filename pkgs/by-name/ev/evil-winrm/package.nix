{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bundlerEnv,
  bundlerUpdateScript,
  writeText,
  krb5,
  sslLegacyProvider ? false,
}:
let
  rubyEnv = bundlerEnv {
    name = "evil-winrm";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
  openssl_conf = writeText "openssl.conf" ''
    openssl_conf = openssl_init

    [openssl_init]
    providers = provider_sect

    [provider_sect]
    default = default_sect
    legacy = legacy_sect

    [default_sect]
    activate = 1

    [legacy_sect]
    activate = 1
  '';
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

  postFixup = lib.optionalString sslLegacyProvider ''
    wrapProgram $out/bin/evil-winrm \
      --prefix OPENSSL_CONF : "${openssl_conf}" \
      --prefix LD_LIBRARY_PATH : ${krb5.lib}/lib
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
