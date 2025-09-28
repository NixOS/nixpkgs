{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  vte,
  gtk3,
  pcre2,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "stupidterm";
  version = "2019-03-26";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    vte
    gtk3
    pcre2
  ];

  src = fetchFromGitHub {
    owner = "esmil";
    repo = "stupidterm";
    rev = "f824e41c2ca9016db73556c5d2f5a2861e235c8e";
    sha256 = "1f73wvqqvj5pr3fvb7jjc4bi1iwgkkknz24k8n69mdb75jnfjipp";
  };

  makeFlags = [
    "PKGCONFIG=${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config"
    "binary=stupidterm"
  ];

  installPhase = ''
    install -D stupidterm $out/bin/stupidterm
    install -D -m 644 stupidterm.desktop $out/share/applications/stupidterm.desktop
    install -D -m 644 stupidterm.ini $out/share/stupidterm/stupidterm.ini

    substituteInPlace $out/share/applications/stupidterm.desktop \
      --replace "Exec=st" "Exec=$out/bin/stupidterm"
  '';

  passthru.tests.test = nixosTests.terminal-emulators.stupidterm;

  meta = with lib; {
    description = "Simple wrapper around the VTE terminal emulator widget for GTK";
    homepage = "https://github.com/esmil/stupidterm";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "stupidterm";
  };
}
