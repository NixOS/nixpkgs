{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, pam
, pam_u2f
, stdenv
, wayland
, noX11 ? false
, noU2f ? false
,
}:
buildGoModule rec {
  pname = "emptty-unwrapped";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8JVF3XNNzmcaJCINnv8B6l2IB5c8q/AvGOzwAlIFYq8=";
  };

  buildInputs =
    [ wayland pam ]
    ++ (lib.lists.optionals (!noX11) [ libX11 ])
    ++ (lib.lists.optionals (!noU2f) [ pam_u2f ]);

  vendorHash = "sha256-tviPb05puHvBdDkSsRrBExUVxQy+DzmkjB+W9W2CG4M=";

  tags = lib.lists.optionals noX11 [ "noxlib" ];

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    make DESTDIR=$out install
    make DESTDIR=$out install-manual
    # make DESTDIR=$out install-systemd

    if [ -d $out/usr ]; then
      mv $out/usr/* $out
      rmdir $out/usr
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dead simple CLI Display Manager on TTY";
    homepage = "https://github.com/tvrzna/emptty";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom the-argus ];
    # many undefined functions
    broken = stdenv.isDarwin;
  };
}
