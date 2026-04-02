# GPU Screen Recorder Workspace Recording {#module-programs-gpu-screen-recorder-workspace-recording}

`gpu-screen-recorder` can be started as a user service to continuously
record the active Wayland workspace. This is configured with
{option}`programs.gpu-screen-recorder.workspaceRecording.enable`.

A minimal configuration looks like this:

```nix
{
  programs.gpu-screen-recorder = {
    enable = true;
    workspaceRecording.enable = true;
  };
}
```

When enabled, NixOS starts the
`gpu-screen-recorder-workspace-recording.service` user unit as part of
`graphical-session.target`. Recordings are written to
{option}`programs.gpu-screen-recorder.workspaceRecording.outputDirectory`
and use timestamp-based filenames.

The service assumes a Wayland session with PipeWire and a user D-Bus
session available. On compositor setups that start `graphical-session.target`
before all user session sockets are ready, keep
{option}`programs.gpu-screen-recorder.workspaceRecording.waitForSession`
enabled so the service waits for the `wayland-*`, `pipewire-0`, and
`bus` sockets in `XDG_RUNTIME_DIR`.

Chunked recording is enabled by default through
{option}`programs.gpu-screen-recorder.workspaceRecording.chunking.enable`.
This periodically restarts the user service so recordings are split
across multiple files instead of growing without bound. Suspend and
resume handling is also enabled by default through
{option}`programs.gpu-screen-recorder.workspaceRecording.handleSleep`,
which stops recording before suspend and starts it again after resume.

For example:

```nix
{
  programs.gpu-screen-recorder = {
    enable = true;

    workspaceRecording = {
      enable = true;
      outputDirectory = "%h/Videos/recordings/workspace";
      fps = 30;
      codec = "av1";
      audioSources = "default_output";

      chunking = {
        minimumDurationMinutes = 20;
        maximumDurationMinutes = 45;
      };
    };
  };
}
```

Useful commands while debugging:

```console
$ systemctl --user status gpu-screen-recorder-workspace-recording.service
$ journalctl --user -u gpu-screen-recorder-workspace-recording.service -f
$ systemctl --user status gpu-screen-recorder-workspace-recording-restart.timer
```

If the service fails immediately after session startup, check that:

- `WAYLAND_DISPLAY` points to a socket inside `XDG_RUNTIME_DIR`.
- PipeWire is enabled and has created `XDG_RUNTIME_DIR/pipewire-0`.
- A user D-Bus socket exists at `XDG_RUNTIME_DIR/bus`.

If you need compositor-specific command-line flags, append them with
{option}`programs.gpu-screen-recorder.workspaceRecording.extraArgs`.
