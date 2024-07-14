{ lib
, fetchFromGitHub
, pkg-config
, flutter
, buildGoModule
, libayatana-appindicator
}:
let
  pname = "hiddify-next";
  version = "1.5.2";

  hiddify = fetchFromGitHub {
    owner = "hiddify";
    repo = "hiddify-next";
    rev = "v${version}";
    hash = "sha256-2dzlieKikhjpi1nc86Gloqdllb30u0RgDD6sJTRSv0Q=";
    fetchSubmodules = true;
  };

  hiddify-core = buildGoModule rec {
    pname = "hiddify-core";
    inherit version;

    src = "${hiddify}/libcore";

    vendorHash = "sha256-hnEaQYXyYLh5rwnHYZn6ZCMvIHZkpUV2y9HF21b7tnk=";

    ldflags = [ "-s" "-w" ];

    GO_PUBLIC_FLAGS = ''
      -tags "with_gvisor,with_quic,with_wireguard,with_ech,with_utls,with_clash_api,with_grpc" \
      -trimpath \
    '';

    buildPhase = ''
      runHook preBuild

      go build ${GO_PUBLIC_FLAGS} -buildmode=c-shared -o libcore.so ./custom
      CGO_LDFLAGS=libcore.so go build ${GO_PUBLIC_FLAGS} -o HiddifyCli ./cli/bydll

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib}

      cp HiddifyCli $out/bin
      cp libcore.so $out/lib

      runHook postInstall
    '';
  };
in flutter.buildFlutterApplication {
  inherit pname version;

  src = hiddify;

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  strictDeps = true;

  buildInputs = [ libayatana-appindicator ];

  nativeBuildInputs = [ pkg-config ];

  preBuild = ''
    pushd libcore/bin
    ln -s ${hiddify-core}/lib lib
    ln -s ${hiddify-core}/bin/HiddifyCli HiddifyCli
    popd
    flutter pub run build_runner build --delete-conflicting-outputs
    flutter pub run slang
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/lib"
  '';

  gitHashes = {
    circle_flags = "sha256-dqORH4yj0jU8r9hP9NTjrlEO0ReHt4wds7BhgRPq57g=";
  };

  meta = with lib; {
    description = "Multi-platform auto-proxy client, supporting Sing-box, X-ray, TUIC, Hysteria, Reality, Trojan, SSH etc. It’s an open-source, secure and ad-free. ";
    homepage = "https://github.com/hiddify/hiddify-next/";
    mainProgram = "hiddify";
    license = licenses.cc-by-nc-sa-40;
    platforms = platforms.linux;
    maintainers = with maintainers; [ BeiyanYunyi ChaosAttractor ];
  };
}
