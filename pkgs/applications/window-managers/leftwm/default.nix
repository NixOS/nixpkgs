{ stdenv, fetchFromGitHub, rustPlatform, libX11, libXinerama, makeWrapper }:

let 
    rpath = stdenv.lib.makeLibraryPath [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
    pname = "leftwm";
    version = "0.1.10";

    src = fetchFromGitHub {
        owner = "leftwm";
        repo = "leftwm";
        rev = version;
        sha256 = "190lc48clkh9vzlsfg2a70w405k7xyyw7avnxwna1glfwmbyy2ag";
    };

    buildInputs = [ makeWrapper libX11 libXinerama ];

    postInstall = ''
        wrapProgram $out/bin/leftwm --prefix LD_LIBRARY_PATH : "${rpath}"
        wrapProgram $out/bin/leftwm-state --prefix LD_LIBRARY_PATH : "${rpath}"
        wrapProgram $out/bin/leftwm-worker --prefix LD_LIBRARY_PATH : "${rpath}"
    '';

    cargoSha256 = "0mpvfix7bvc84vanha474l4gaq97ac1zy5l77z83m9jg0246yxd6";

    # patch wrong version in Cargo.lock
    cargoPatches = [ ./cargo-lock.patch ];

    meta = {
        description = "Leftwm - A tiling window manager for the adventurer";
        homepage = https://github.com/leftwm/leftwm;
        license = stdenv.lib.licenses.mit;
        platforms = stdenv.lib.platforms.linux;
        maintainers = with stdenv.lib.maintainers; [ mschneider ];
    };
}
