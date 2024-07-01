{
  stdenv,
  pkg-config,
  criterion,
}:
stdenv.mkDerivation rec {
  name = "version-tester";
  version = "v${criterion.version}";
  src = ./test_dummy.c;

  dontUnpack = true;
  buildInputs = [ criterion ];
  nativeBuildInputs = [ pkg-config ];

  buildPhase = ''
    cc -o ${name} $src `pkg-config --libs criterion`
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin/${name}
  '';

  meta.mainProgram = name;
}
