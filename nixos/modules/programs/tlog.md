# tlog {#module-programs-tlog}

[tlog](https://github.com/Scribery/tlog) records terminal I/O of user
sessions, by default to the systemd journal, and replays it with
{command}`tlog-play`.

## Recording a user's sessions {#module-programs-tlog-usage}

Enabling the module installs {command}`tlog-rec-session` as a setuid
wrapper. Make it the login shell of every user who should be recorded; the
shell that actually runs is
[](#opt-programs.tlog.settings.rec-session.shell).

```nix
{ config, ... }:
{
  programs.tlog.enable = true;
  users.users.alice.shell = "${config.security.wrapperDir}/tlog-rec-session";
}
```

Console and SSH logins of `alice` are now recorded. Only terminal output is
logged by default; set `programs.tlog.settings.rec-session.log.input = true`
to also log input, keeping in mind that this captures passwords typed into
the session.

tlog records each audit session once: the first {command}`tlog-rec-session`
in a session takes a lock in {file}`/run/tlog`, and nested ones (for example
`su - alice` from an already recorded session) run unrecorded, since their
output is already captured by the outer one. Sessions without an audit
session ID share a single lock.

Invalid `settings` (unknown keys, wrong types) fail the system build rather
than locking recorded users out at login.

## Replaying a session {#module-programs-tlog-replay}

Each recording carries a `TLOG_REC` journal field:

```shell
journalctl TLOG_USER=alice -o verbose | grep TLOG_REC
tlog-play -r journal -M TLOG_REC=<id>
```
