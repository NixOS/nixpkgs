{ stdenv, fetchFromGitHub, xmpppy, pydns, substituteAll, buildEnv }:

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

  patches = [
    (substituteAll {
      src = ./libpath.patch;
      env = "${buildEnv {
        name = "weechat-xmpp-env";
        paths = [ pydns xmpppy ];
      }}/lib/python2.7/site-packages";
    })
  ];

  passthru.scripts = [ "jabber.py" ];

  meta = with stdenv.lib; {
    description = "A fork of the jabber plugin for weechat";
    homepage = "https://github.com/sleduc/weechat-xmpp";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.gpl3Plus;
  };
}
