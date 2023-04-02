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
  pname = "emptty";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = pname;
    rev = "18de1cefcbff00e3468abe5573a2af2d848e7553";
    sha256 = "0jzhcbw1ckpsmmxm2g51lvkspsrl7lkn9xfifkk97mvm22qs4p49";
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
