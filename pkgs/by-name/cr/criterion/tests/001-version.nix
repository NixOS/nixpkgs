{
  stdenv,
  pkg-config,
  criterion,
}:
stdenv.mkDerivation {
  pname = "version-tester";
  inherit (criterion) version;

  __structuredAttrs = true;
  strictDeps = true;

  src = ./test_dummy.c;

  dontUnpack = true;
  buildInputs = [ criterion ];
  nativeBuildInputs = [ pkg-config ];

  buildPhase = ''
    cc -o version-tester $src `pkg-config --libs criterion`
  '';

  installPhase = ''
    install -Dm477 version-tester -t $out/bin
  '';

  meta.mainProgram = "version-tester";
}
