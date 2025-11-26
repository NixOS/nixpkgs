# GitLab Runner {#module-services-gitlab-runner}

GitLab Runner is a CI runner which is an executable which you can host yourself.
A Gitlab pipeline runs operations over a Gitlab Runner. These can include
building an executable, running a test suite, pushing a docker image, etc. The
Gitlab Runner receives jobs from Gitlab which it then dispatches to the
configured executors
([`docker` (`podman`), or `shell` or `kubernetes`](https://docs.gitlab.com/runner/executors)).

The
[services.gitlab-runner.services](https://search.nixos.org/options?query=services.gitlab-runner.services)
documents a number of typical setups to configure multiple runners with
different executors.

The [below example](#ex-gitlab-runner-podman) gives a **more elaborate** example how to
configure a Gitlab Runner with caching and reasonably good security practices.

::: {#ex-gitlab-runner-podman .example}

## Example Gitlab Runner with `podman` and Nix Store Caching

The [VM tested podman-runner](../../../../../nixos/tests/gitlab/runner/podman-runner/default.nix) (a NixOS Module for reuse) configures a Gitlab Runner with the following
features:

- The executor is `podman` which gives you better additional safety than
  `docker`. That means every job is run in a `podman` container.

- The following container **images** are built with Nix:

  **Container Images for Gitlab Jobs**:
  - `local/alpine`: An image based on Alpine with a Nix installation
    (variable `alpineImage`).
  - `local/ubuntu`: An image based on Ubuntu with a Nix installation
    (variable `ubuntuImage`).
  - `local/nix`: An image based on Nix which only comes with `nix`
    installed (variable `nixImage`).

  **Images for VM Setup**:
  - `local/nix-daemon-image`: An image with a Nix daemon which is
    used to share the `/nix/store` across jobs (variable `nixDaemonImage`).
  - `local/podman-daemon-image`: An image with a `podman` running as a daemon which is
    used to run `podman` inside the above job containers images
    (variable `podmanDaemonImage`).

- Every job container runs in a `podman` container instance based by default on
  `ubuntuImage`. A pipeline job can override this with `image: local/alpine`.
  - Each job container will have the `/nix/store` mounted from a container
    `nix-daemon-container` (see registration flags
    `--docker-volumes-from "nix-daemon-container:ro"`).

    The `nix-daemon-container` is a single container instance of a
    `nixDaemonImage`. This enables caching of `/nix/store` paths across all jobs
    in **all** runners. This makes **the host VM's `/nix/store` independent of the
    Nix store used in the jobs**, which is good.

    **Security:** If you don't want this you need multiple `nixDaemonImage`
    containers for each registered runner (`gitlab-runner.services.<name>`).

  - Each job container will have the `/run/podman/podman.sock` socket mounted from the
    `podman-daemon-container`.

    The `podman-daemon-container` is a single container of `podmanDaemonImage` which runs
    `podman` as a daemon. Job containers can use this daemon to spawn nested containers as well (podman-in-podman). **Keep in mind that `bind` mounts are local to the `podman-daemon-container`** and can be be worked around with a `podman volume create <vol>` and manual copy-to/copy-from this volume `<vol>`.

    If you only need to build containers you don't need this feature (`podman-daemon-container`), see below point.

    Container configuration files (`auxRootFiles`) are copied to all containers to
    ensure `podman` works inside the job containers.

  - The job containers do **not** mount the `podman` socket from the host (NixOS
    VM) mounted for security reasons.

    **Note:** Building container images with `buildah` (stripped
    `podman` for building images) inside a job which runs `alpineImage`
    is still possible.

:::
