{
  fetchFromGitHub,
  glibc,
  isa ? "x86", # x86, arm, thumb, sparc, arm64, or riscv
  lib,
  scons,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m5ops-${isa}";
  version = "24.1.0.3";

  src = fetchFromGitHub {
    owner = "gem5";
    repo = "gem5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MLceCx4Sv+LHDXdmc4wuIArDZjelh7dDqmnPGNVJ2zo=";
  };

  nativeBuildInputs = [ scons ];

  buildInputs = [ glibc.static ];

  sourceRoot = "source/util/m5";

  buildFlags = [ "build/${isa}/out/m5" ];

  # Needed so the build script doesn't hide all Nix environment variables.
  postPatch = ''
    substituteInPlace SConstruct \
      --replace-fail "Environment()" "Environment(ENV=os.environ)"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp build/${isa}/out/m5 $out/bin/
    cp build/${isa}/out/libm5.a $out/lib/
    cp -r ../../include $out/include

    runHook postInstall
  '';

  meta = {
    description = "Special instructions for gem5";
    homepage = "https://www.gem5.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
