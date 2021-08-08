{ i3lock-color, lib, fetchFromGitHub }:

i3lock-color.overrideAttrs (oldAttrs : rec {
  pname = "i3lock-blur";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "karulont";
    repo = "i3lock-blur";
    rev = version;
    sha256 = "sha256-rBQHYVD9rurzTEXrgEnOziOP22D2EePC1+EV9Wi2pa0=";
  };

  meta = with lib; {
    description = "An improved screenlocker based upon XCB and PAM with background blurring filter";
    homepage = "https://github.com/karulont/i3lock-blur/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.all;
  };
})
