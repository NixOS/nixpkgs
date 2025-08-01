{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gopsuinfo";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "gopsuinfo";
    rev = "v${version}";
    sha256 = "sha256-h+CdiQh7IguCduIMCCI/UPIUAdXlNSHdkz6hrG10h3c=";
  };

  vendorHash = "sha256-S2ZHfrbEjPDweazwWbMbEMcMl/i+8Nru0G0e7RjOJMk=";

  # Remove installing of binary from the Makefile (already taken care of by
  # `buildGoModule`)
  patches = [
    ./no_bin_install.patch
  ];

  # Fix absolute path of icons in the code
  postPatch = ''
    substituteInPlace gopsuinfo.go \
      --replace "/usr/share/gopsuinfo" "$out/usr/share/gopsuinfo"
  '';

  # Install icons
  postInstall = ''make install DESTDIR=$out'';

  meta = with lib; {
    description = "Gopsutil-based command to display system usage info";
    homepage = "https://github.com/nwg-piotr/gopsuinfo";
    license = licenses.bsd2;
    maintainers = with maintainers; [ otini ];
    platforms = platforms.linux;
    mainProgram = "gopsuinfo";
  };
}
