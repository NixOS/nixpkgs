{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gcc,
}:

stdenv.mkDerivation rec {
  pname = "pvsneslib";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "alekmaul";
    repo = "pvsneslib";
    tag = version;
    hash = "sha256-Cl4+WvjKbq5IPqf7ivVYwBYwDDWWHGNeq4nWXPxsUHw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc
    cmake
  ];

  dontConfigure = true;

  postPatch = ''
    substituteInPlace tools/816-opt/Makefile \
      --replace-fail 'LDFLAGS := -lpthread' 'LDFLAGS :=' \
      --replace-fail 'LDFLAGS := -pthread' 'LDFLAGS += -pthread' \
      --replace-fail 'LDFLAGS += -lpthread -static' '# LDFLAGS += -lpthread -static'

    substituteInPlace tools/bin2txt/Makefile \
                                    tools/gfx2snes/Makefile \
                                    tools/gfx4snes/Makefile \
                                    tools/snestools/Makefile \
                                    tools/816-opt/Makefile \
                                    tools/tmx2snes/Makefile \
      --replace-fail '$(CFLAGS) $(OBJS)' '$(LDFLAGS) $(OBJS)'

    substituteInPlace tools/smconv/Makefile \
      --replace-fail '$(CFLAGS) $(LDFLAGS)' '$(LDFLAGS)'

    substituteInPlace tools/constify/Makefile \
      --replace-fail '$(CFLAGS) $(DEFINES) $(OBJS)' '$(LDFLAGS) $(DEFINES) $(OBJS)'

    substituteInPlace tools/snestools/Makefile \
      --replace-fail '-Wno-format' ' '

    substituteInPlace tools/snesbrr/brr/Makefile \
      --replace-fail 'LDFLAGS ' 'LDFLAGS :=
      LDFLAGS '

    substituteInPlace compiler/wla-dx/wlalink/write.c \
      --replace-fail 'sort_anonymous_labels()' 'sort_anonymous_labels(void)'
  '';

  preBuild = ''
    export PVSNESLIB_HOME=$(pwd)
  '';

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Free and open source development kit for the Nintendo SNES";
    homepage = "https://github.com/alekmaul/pvsneslib";
    changelog = "https://github.com/alekmaul/pvsneslib/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "pvsneslib";
    platforms = lib.platforms.all;
  };
}
