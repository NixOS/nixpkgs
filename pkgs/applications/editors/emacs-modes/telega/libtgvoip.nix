{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, libopus
, openssl
, libpulseaudio
, alsaLib
, patchelf
}:

let
  version = "2.4.4";

in stdenv.mkDerivation {
  pname = "libtgvoip";
  inherit version;

  src = fetchFromGitHub {
    owner = "grishka";
    repo = "libtgvoip";
    rev = version;
    sha256 = "122kn3jx6v0kkldlzlpzvlwqxgp6pmzxsjhrhcxw12bx9c08sar5";
  };

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional stdenv.isLinux patchelf;
  buildInputs = [ libopus openssl  ]
    ++ lib.optionals stdenv.isLinux [ alsaLib libpulseaudio ];

  # libtgvoip wants to dlopen libpulse and libasound, so tell it where they are.
  postFixup = lib.optionalString stdenv.isLinux ''
    so=$(readlink -f $out/lib/libtgvoip.so)
    patchelf --set-rpath ${lib.makeLibraryPath [ libpulseaudio alsaLib ]}:$(patchelf --print-rpath "$so") "$so"
  '';

  meta = {
    description = ''
      A collection of libraries and header files for implementing telephony functionality into custom Telegram clients.
    '';
    license = lib.licenses.unlicense;
  };

}
