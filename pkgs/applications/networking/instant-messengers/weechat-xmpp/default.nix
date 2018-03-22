{ stdenv, fetchFromGitHub, xmpppy }:

stdenv.mkDerivation {
  name = "weechat-jabber-2017-08-30";

  src = fetchFromGitHub {
    repo = "weechat-xmpp";
    owner = "sleduc";
    sha256 = "0s02xs0ynld9cxxzj07al364sfglyc5ir1i82133mq0s8cpphnxv";
    rev = "8f6c21f5a160c9318c7a2d8fd5dcac7ab2e0d843";
  };

  installPhase = ''
    mkdir -p $out/share
    cp jabber.py $out/share/jabber.py
  '';

  buildInputs = [ xmpppy ];

  postPatch = ''
    substituteInPlace jabber.py \
      --replace "__NIX_OUTPUT__" "${xmpppy}/lib/python2.7/site-packages"
  '';

  patches = [
    ./libpath.patch
  ];

  meta = with stdenv.lib; {
    description = "A fork of the jabber plugin for weechat";
    homepage = "https://github.com/sleduc/weechat-xmpp";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.gpl3Plus;
  };
}
