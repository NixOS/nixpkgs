{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  sqlite,
  pkg-config,
  xapian,
  icu,
}:
{
  dovecot,
}:

stdenv.mkDerivation rec {
  pname = "dovecot-fts-xapian";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = version;
    hash = "sha256-+8THyzzBV8QQVQFeKCSvIzkr5oaE0vdWU2gsolChfoo=";
  };

  buildInputs = [
    xapian
    icu
    sqlite
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # patching dovecot_moduledir in ${dovecot}/lib/dovecot/dovecot-config to point to $out/lib/dovecot/modules instead of ${dovecot}/lib/dovecot/modules
  # context: https://github.com/NixOS/nixpkgs/pull/388463#issuecomment-2722222944
  postPatch = ''
    mkdir dovecot
    install -m 644 ${dovecot}/lib/dovecot/dovecot-config dovecot
    substituteInPlace dovecot/dovecot-config --replace-fail \
      "dovecot_moduledir=${dovecot}/lib/dovecot/modules" \
      "dovecot_moduledir=${placeholder "out"}/lib/dovecot/modules"
  '';

  preConfigure = ''
    export PANDOC=false
  '';

  configureFlags = [
    # referencing the patched dovecot-config created in postPatch
    "--with-dovecot=/build/source/dovecot"
  ];

  meta = with lib; {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    changelog = "https://github.com/grosjo/fts-xapian/releases";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [
      julm
      symphorien
    ];
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/dovecot_fts_xapian.x86_64-darwin
  };
}
