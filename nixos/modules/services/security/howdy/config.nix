{
  core = {
    detection_notice = false;
    timeout_notice = true;
    no_confirmation = false;
    suppress_unknown = false;
    abort_if_ssh = true;
    abort_if_lid_closed = true;
    disabled = false;
    use_cnn = false;
    workaround = "off";
  };

  video = {
    certainty = 3.5;
    timeout = 4;
    device_path = "/dev/video2";
    warn_no_device = true;
    max_height = 320;
    frame_width = -1;
    frame_height = -1;
    dark_threshold = 60;
    recording_plugin = "opencv";
    device_format = "v4l2";
    force_mjpeg = false;
    exposure = -1;
    device_fps = -1;
    rotate = 0;
  };

  snapshots = {
    save_failed = false;
    save_successful = false;
  };

  rubberstamps = {
    enabled = false;
    stamp_rules = "nod		5s		failsafe     min_distance=12";
  };

  debug = {
    end_report = false;
    verbose_stamps = false;
    gtk_stdout = false;
  };
}
