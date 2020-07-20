{ stdenv, buildGoPackage, fetchFromGitHub, fetchurl, pkgconfig, libseccomp, go
, qemu }:

let
  version = "1.11.2";

  # prepare source to have a structure of GOPATH
  setSourceRoot = ''
    mkdir -p "go/src/$(dirname "$goPackagePath")"
    cp -R source "go/src/$goPackagePath"
    export sourceRoot="go/src/$goPackagePath"
  '';

  # default make flags, set GOPATH, GOCACHE and install prefix
  makeFlags = [
    "GOPATH=$(NIX_BUILD_TOP)/go"
    "GOCACHE=$(TMPDIR)/go-cache"
    "PREFIX=$(out)"
  ];

  # default meta
  meta = with stdenv.lib; {
    homepage = "https://katacontainers.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };

  agent = stdenv.mkDerivation {
    pname = "kata-agent";
    inherit version;

    src = fetchFromGitHub {
      owner = "kata-containers";
      repo = "agent";
      rev = version;
      sha256 = "6Zr7qwBuidJmKdZL2VGmRlKthWletdc0fRS5kA54CHM=";
    };

    goPackagePath = "github.com/kata-containers/agent";

    inherit setSourceRoot;

    nativeBuildInputs = [ pkgconfig go ];
    buildInputs = [ libseccomp ];

    makeFlags = makeFlags ++ [
      "UNIT_DIR=$(out)/lib/systemd/system"
      "SECCOMP=yes"
    ];

    meta = meta // {
      description = "Kata Containers version 1.x agent";
    };
  };

  ksm-throttler = stdenv.mkDerivation {
    pname = "kata-ksm-throttler";
    inherit version;

    src = fetchFromGitHub {
      owner = "kata-containers";
      repo = "ksm-throttler";
      rev = version;
      sha256 = "l+3pMjsfxU8170JKslhqv7PbaU3ROSQoscGQNbNh3+k=";
    };

    goPackagePath = "github.com/kata-containers/ksm-throttler";

    nativeBuildInputs = [ go ];

    inherit setSourceRoot makeFlags;

    meta = meta // {
      description = "Kata Containers KSM throttling daemon";
    };
  };

  proxy = stdenv.mkDerivation {
    pname = "kata-proxy";
    inherit version;

    src = fetchFromGitHub {
      owner = "kata-containers";
      repo = "proxy";
      rev = version;
      sha256 = "M2WaODisDPcpSc5AaMJEWI6MiF8Q1Iz/R6HzqFycOC8=";
    };

    goPackagePath = "github.com/kata-containers/proxy";

    nativeBuildInputs = [ go ];

    inherit setSourceRoot makeFlags;

    meta = meta // {
      description = "Kata Containers version 1.x proxy";
    };
  };

  shim = stdenv.mkDerivation {
    pname = "kata-shim";
    inherit version;

    src = fetchFromGitHub {
      owner = "kata-containers";
      repo = "shim";
      rev = version;
      sha256 = "sQHGCQ1Vowd6Zvm0wrN5Y2lEPzySkE1xlBt7tn3NppU=";
    };

    inherit setSourceRoot makeFlags;

    goPackagePath = "github.com/kata-containers/shim";

    nativeBuildInputs = [ go ];

    meta = meta // {
      description = "Kata Containers version 1.x shim";
    };
  };

  runtime = stdenv.mkDerivation {
    pname = "kata-runtime";
    inherit version;

    src = fetchFromGitHub {
      owner = "kata-containers";
      repo = "runtime";
      rev = version;
      sha256 = "TsXkkENZhH/p2SA4ytsWTiY5SJX+9FxUiX1o/v9RObo=";
    };

    goPackagePath = "github.com/kata-containers/runtime";

    nativeBuildInputs = [ go ];

    inherit setSourceRoot;

    makeFlags = makeFlags ++ [
      "SKIP_GO_VERSION_CHECK=true"
    ];

    patchPhase = ''
      substituteInPlace Makefile --replace '-i -o' '-o'
    '';

    meta = meta // {
      description = "Kata Containers version 1.x runtime";
    };
  };

  images = stdenv.mkDerivation {
    pname = "kata-container-images";
    inherit version;

    src = fetchurl {
      url =
        if stdenv.isx86_64
        then "https://github.com/kata-containers/runtime/releases/download/${version}/kata-static-${version}-x86_64.tar.xz"
        else throw "unsupported platform ${stdenv.system}";
      sha256 = "ai9n/Kb4llAqazuot1GMq/8my0RI4PUpy+/kA5kJdY8=";
    };

    installPhase = ''
      install -Dm644 -t "$out/share/kata-containers/" \
        kata/share/kata-containers/vmlinux-* \
        kata/share/kata-containers/vmlinuz-*
      install -Dm644 -t "$out/share/kata-containers/" \
        kata/share/kata-containers/config-*
      install -Dm644 -t "$out/share/kata-containers/" \
        kata/share/kata-containers/kata-containers*.img

      cd "$out/share/kata-containers/"
      ln -s vmlinux-[0-9].[0-9]* vmlinux.container
      ln -s vmlinuz-[0-9].[0-9]* vmlinuz.container
    '';

    meta = meta // {
      description = "Kata Containers version 1.x images";
    };
  };

  runtime-qemu = stdenv.lib.overrideDerivation runtime (p: {
    makeFlags = p.makeFlags ++ [
      "SHIMPATH=${shim}/libexec/kata-containers/kata-shim"
      "PROXYPATH=${proxy}/libexec/kata-containers/kata-proxy"
      "QEMUBINDIR=${qemu}/bin"
      "INITRDPATH=${images}/share/kata-containers/kata-containers-initrd.img"
      "KERNELDIR=${images}/share/kata-containers"
    ];
  });

in {
  inherit agent ksm-throttler proxy shim runtime images runtime-qemu;
}
