{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, pkg-config
, utilmacros
, libX11
, libXaw
, libXmu
, libXt
}:

stdenv.mkDerivation rec {
  pname = "xedit";
  version = "1.2.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xorg/app";
    repo = "xedit";
    rev = "${pname}-${version}";
    sha256 = "sha256-0vP+aR8QBXAqbULOLEs7QXsehk18BJ405qoelrcepwE=";
  };

  # ./lisp/mathimp.c:493:10: error: implicitly declaring library function 'finite' with type 'int (double)'
  postPatch = lib.optionalString stdenv.isDarwin ''
    for i in $(find . -type f -name "*.c"); do
      substituteInPlace $i --replace "finite" "isfinite"
    done
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config utilmacros ];
  buildInputs = [
    libX11
    libXaw
    libXmu
    libXt
  ];

  configureFlags = [
    "--with-lispdir=$out/share/X11/xedit/lisp"
    "--with-appdefaultdir=$out/share/X11/app-defaults"
  ];

  meta = with lib; {
    description = "Simple graphical text editor using Athena Widgets (Xaw)";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xedit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.unix;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
    mainProgram = "xedit";
  };
}
