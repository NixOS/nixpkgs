# tlog {#module-programs-tlog}

[tlog](https://github.com/Scribery/tlog) records terminal I/O of user sessions, by default to the systemd journal, and replays it with {command}`tlog-play`.

## Recording a user's sessions {#module-programs-tlog-usage}

```nix
{
  programs.tlog.enable = true;
  programs.tlog.users = [ "alice" ];
}
```

Console and SSH logins of `alice` are now recorded.
The login shell of each user in [](#opt-programs.tlog.users) becomes the setuid {command}`tlog-rec-session` wrapper, which runs [](#opt-programs.tlog.settings.rec-session.shell), the same shell for all of them.
Only terminal output is logged by default; set `programs.tlog.settings.rec-session.log.input = true` to also log input, keeping in mind that this captures passwords typed into the session.

Users not declared in [](#opt-users.users), such as LDAP or SSSD users, cannot be listed.
Set their login shell to {file}`/run/wrappers/bin/tlog-rec-session` in the directory instead.

tlog records each audit session once: the first {command}`tlog-rec-session` in a session takes a lock in {file}`/run/tlog`, and nested ones (for example `su - alice` from an already recorded session) run unrecorded, since their output is already captured by the outer one.

Unknown keys and wrong types in `settings` fail the system build rather than locking recorded users out at login.
This check runs the tlog binaries, so it is skipped when cross-compiling.

## Limitations {#module-programs-tlog-limitations}

- Processes without an audit session ID all share one lock, so while one of them is recorded, every other one runs unrecorded.
  Console and SSH logins get an audit session ID; {command}`su` and {command}`runuser` started from a system service do not, unless [](#opt-security.pam.services._name_.setLoginUid) is enabled for them.
- The wrapper is not listed in {file}`/etc/shells`, so recorded users cannot {command}`chsh` away from it.
  Services that check that file with `pam_shells`, such as GDM, refuse recorded users unless you add it to [](#opt-environment.shells).
- The recorded shell is not a login shell: the setuid wrapper replaces `argv[0]`, so tlog never sees the leading `-` that {command}`login` and {command}`sshd` pass.
  Interactive bash still loads {file}`/etc/profile`, through {file}`/etc/bashrc`; non-interactive commands such as `su - alice -c ...` do not.
- {command}`tlog-rec-session` applies the `TLOG_REC_SESSION_CONF_FILE`, `TLOG_REC_SESSION_CONF_TEXT` and `TLOG_REC_SESSION_SHELL` environment variables on top of {file}`/etc/tlog/tlog-rec-session.conf`.
  Do not let recorded users set environment variables at login, for example with `PermitUserEnvironment` or `AcceptEnv` in [](#opt-services.openssh.settings).
- If `root` is listed in [](#opt-programs.tlog.users), {command}`sulogin` runs the rescue and emergency shells through tlog too, so a tlog failure there leaves no recovery shell.
- With [](#opt-systemd.sysusers.enable), an account that already exists, such as `root`, keeps its old login shell when it is added to [](#opt-programs.tlog.users) later, because {command}`systemd-sysusers` does not change existing accounts.

## Replaying a session {#module-programs-tlog-replay}

Each recording carries a `TLOG_REC` journal field:

```ShellSession
$ journalctl TLOG_USER=alice -o verbose | grep TLOG_REC
$ tlog-play -r journal -M TLOG_REC=<id>
```
