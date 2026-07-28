{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  pandoc,
  systemd,
  util-linux,
  acl,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "jai-jail";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "stanford-scs";
    repo = "jai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AByC7Xh1FYbQ/4Au396m2zYUxsLqcF1PEbpdz7x6LaQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pandoc
    systemd
  ];

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    util-linux # libmount
    acl
  ];

  configureFlags = [ "--with-untrusted-user=jai" ];

  meta = {
    description = "Lightweight jail for AI CLIs";
    mainProgram = "jai";
    homepage = "https://jai.scs.stanford.edu";
    changelog = "https://github.com/stanford-scs/jai/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ agentelement ];
    platforms = lib.platforms.linux;
  };
})
