- [`sudo-rs`], a reimplementation of `sudo` in Rust, is now supported.
  An experimental new module `security.sudo-rs` was added.
  Switching to it (via `security.sudo.enable = false; security.sudo-rs.enable = true;`) introduces
  slight changes in sudo behaviour, due to `sudo-rs`' current limitations:
  - terminfo-related environment variables aren't preserved for `root` and `wheel`;
  - `root` and `wheel` are not given the ability to set (or preserve)
    arbitrary environment variables.

[`sudo-rs`]: https://github.com/memorysafety/sudo-rs/
