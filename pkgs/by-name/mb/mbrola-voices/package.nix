{ lib, fetchFromGitHub }:

# Very big (0.65 G) so kept as a fixed-output derivation to limit "duplicates".
fetchFromGitHub {
  pname = "mbrola-voices";
  version = "0-unstable-2020-03-30";

  owner = "numediart";
  repo = "MBROLA-voices";
  rev = "fe05a0ccef6a941207fd6aaad0b31294a1f93a51";
  hash = "sha256-vtPHGC/CoyZeWkKcCydY3GDaccOx3jDGposJodhiL3Y=";

  postFetch = ''
    mkdir -p "$out/share/"{mbrola,doc/mbrola-voices}
    mv "$out/data" "$out/share/mbrola/voices"
    mv "$out/"{LICENSE.md,README.md} "$out/share/doc/mbrola-voices"
  '';

  meta = with lib; {
    description = "Data files of mbrola speech synthesizer voices";
    homepage = "https://github.com/numediart/MBROLA-voices";
    # Choosing to interpret https://github.com/numediart/MBROLA-voices/blob/fe05a0ccef6a941207fd6aaad0b31294a1f93a51/LICENSE.md liberally:
    # “When no charge is made, this database may be copied and distributed freely, provided that this notice is copied and distributed with it.”
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.all;
  };
}
