{ stdenv
, lib
, fetchFromGitHub
, linux-pam
, libxcb
, makeBinaryWrapper
, zig
, callPackage
}:

stdenv.mkDerivation {
  pname = "ly";
  version = "0.6.0-unstable-2024-05-10";

  # The unstable version fixes the issue where configurations are ignored due
  # to a wrong array length during parsing the config file.
  # When the next stable version is released, we should use stable one instead.
  src = fetchFromGitHub {
    owner = "fairyglade";
    repo = "ly";
    rev = "7506d6a7d5ce841ee8c24e5b3eaa930681a39199";
    hash = "sha256-UYTYcgkDMqyIDUigHoOEZEzo2GoeJlTpurSgKOkbt4w=";
  };

  nativeBuildInputs = [ makeBinaryWrapper zig.hook ];
  buildInputs = [ libxcb linux-pam ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/fairyglade/ly";
    maintainers = [ maintainers.vidister ];
    platforms = platforms.linux;
    mainProgram = "ly";
  };
}
