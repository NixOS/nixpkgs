{ stdenv, fetchFromGitHub, rustPlatform, libX11, libXinerama, makeWrapper }:

let 
    rpath = stdenv.lib.makeLibraryPath [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
    pname = "leftwm";
    version = "0.1.9";

    src = fetchFromGitHub {
        owner = "leftwm";
        repo = "leftwm";
        rev = version;
        sha256 = "0ji7m2npkdg27gm33b19rxr50km0gm1h9czi1f425vxq65mlkl4y";
    };

    buildInputs = [ makeWrapper libX11 libXinerama ];

    postInstall = ''
        wrapProgram $out/bin/leftwm --prefix LD_LIBRARY_PATH : "${rpath}"
        wrapProgram $out/bin/leftwm-state --prefix LD_LIBRARY_PATH : "${rpath}"
        wrapProgram $out/bin/leftwm-worker --prefix LD_LIBRARY_PATH : "${rpath}"
    '';

    cargoSha256 = "0mpvfix7bvc84vanha474l4gaq97ac1zy5l77z83m9jg0246yxd6";

    # https://github.com/leftwm/leftwm/pull/37
    cargoPatches = [ ./cargo-lock.patch ];

    meta = {
        description = "Leftwm - A tiling window manager for the adventurer";
        homepage = https://github.com/leftwm/leftwm;
        license = stdenv.lib.licenses.mit;
        platforms = stdenv.lib.platforms.linux;
        maintainers = with stdenv.lib.maintainers; [ mschneider ];
    };
}
