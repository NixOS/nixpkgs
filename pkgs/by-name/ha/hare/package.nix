{ lib
, stdenv
, fetchFromSourcehut
, binutils-unwrapped
, harec
, makeWrapper
, qbe
, scdoc
, tzdata
, substituteAll
}:

let
  # We use harec's override of qbe until 1.2 is released, but the `qbe` argument
  # is kept to avoid breakage.
  qbe = harec.qbeUnstable;
  # https://harelang.org/platforms/
  arch = stdenv.hostPlatform.uname.processor;
  platform = lib.strings.toLower stdenv.hostPlatform.uname.system;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hare";
  version = "unstable-2023-11-27";

  outputs = [ "out" "man" ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare";
    rev = "d94f355481a320fb2aec13ef62cb3bfe2416f5e4";
    hash = "sha256-Mpl3VO4xvLCKHeYr/FPuS6jl8CkyeqDz18mQ6Zv05oc=";
  };

  patches = [
    # Replace FHS paths with nix store
    (substituteAll {
      src = ./001-tzdata.patch;
      inherit tzdata;
    })
  ];

  nativeBuildInputs = [
    harec
    makeWrapper
    qbe
    scdoc
  ];

  buildInputs = [
    binutils-unwrapped
    harec
    qbe
    tzdata
  ];

  makeFlags = [
    "HARECACHE=.harecache"
    "PREFIX=${builtins.placeholder "out"}"
    "PLATFORM=${platform}"
    "ARCH=${arch}"
  ];

  enableParallelBuilding = true;

  # Append the distribution name to the version
  env.LOCALVER = "nixpkgs";

  strictDeps = true;

  doCheck = true;

  preConfigure = ''
    ln -s config.example.mk config.mk
  '';

  postFixup = ''
    wrapProgram $out/bin/hare \
      --prefix PATH : ${lib.makeBinPath [binutils-unwrapped harec qbe]}
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://harelang.org/";
    description = "Systems programming language designed to be simple, stable, and robust";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "hare";
    inherit (harec.meta) platforms badPlatforms;
  };
})
