{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, asciidoctor
, buildah
, buildah-unwrapped
, cargo
, libiconv
, libkrun
, makeWrapper
, rustc
, sigtool
}:

stdenv.mkDerivation rec {
  pname = "krunvm";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IXofYsOmbrjq8Zq9+a6pvBYsvZFcKzN5IvCuHaxwazI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-Y0FNi/+HuN5SqexHTKjcW6lEaeis7xZDYc2/FOAANIA=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    asciidoctor
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [ sigtool ];

  buildInputs = [ libkrun ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    # do not pollute etc
    substituteInPlace src/utils.rs \
      --replace "etc/containers" "share/krunvm/containers"
  '';

  postInstall = ''
    mkdir -p $out/share/krunvm/containers
    install -D -m755 ${buildah-unwrapped.src}/docs/samples/registries.conf $out/share/krunvm/containers/registries.conf
    install -D -m755 ${buildah-unwrapped.src}/tests/policy.json $out/share/krunvm/containers/policy.json
  '';

  # It attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  dontStrip = stdenv.isDarwin;

  postFixup = ''
    wrapProgram $out/bin/krunvm \
      --prefix PATH : ${lib.makeBinPath [ buildah ]} \
  '';

  meta = with lib; {
    description = "CLI-based utility for creating microVMs from OCI images";
    homepage = "https://github.com/containers/krunvm";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = libkrun.meta.platforms;
    mainProgram = "krunvm";
  };
}
