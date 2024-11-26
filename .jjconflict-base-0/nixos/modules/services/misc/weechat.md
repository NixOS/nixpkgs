# WeeChat {#module-services-weechat}

[WeeChat](https://weechat.org/) is a fast and
extensible IRC client.

## Basic Usage {#module-services-weechat-basic-usage}

By default, the module creates a
[`systemd`](https://www.freedesktop.org/wiki/Software/systemd/)
unit which runs the chat client in a detached
[`screen`](https://www.gnu.org/software/screen/)
session.

This can be done by enabling the `weechat` service:
```nix
{ ... }:

{
  services.weechat.enable = true;
}
```

The service is managed by a dedicated user named `weechat`
in the state directory `/var/lib/weechat`.

## Re-attaching to WeeChat {#module-services-weechat-reattach}

WeeChat runs in a screen session owned by a dedicated user. To explicitly
allow your another user to attach to this session, the
`screenrc` needs to be tweaked by adding
[multiuser](https://www.gnu.org/software/screen/manual/html_node/Multiuser.html#Multiuser)
support:
```nix
{
  programs.screen.screenrc = ''
    multiuser on
    acladd normal_user
  '';
}
```
Now, the session can be re-attached like this:
```
screen -x weechat/weechat-screen
```

*The session name can be changed using [services.weechat.sessionName.](options.html#opt-services.weechat.sessionName)*
