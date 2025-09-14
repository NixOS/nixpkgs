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
different executors. The [below example](#ex-gitlab-runner-podman) gives a **more elaborate** example how to
configure a Gitlab Runner with caching and reasonably good security practices.

::: {#ex-gitlab-runner-podman .example}

## Example Gitlab Runner with `podman` and Nix Store Caching

The [example](./runner.nix) configures a Gitlab Runner with the following
features:

- The executor is `podman` which gives you better additional safety than
  `docker`. That means every job is run in a `podman` container.

- The following container **images** are built with Nix:

  **For Gitlab Jobs**:

  - an image based on Ubuntu (name: `local/alpine`) with a Nix installation used
    for job execution (variable `alpineImage`).
  - an image based on Alpine (name: `local/ubuntu`) with a Nix installation used
    for job execution (variable `ubuntuImage`).
  - an image based on Nix (name: `local/nix`) which only comes with `nix`
    installed. used for job execution (variable `nixImage`).

  **For Setup**

  - an image with (name: `local/nix-daemon-image`) with a Nix daemon which is
    used to share the `/nix/store` across jobs (variable `nixDaemonImage`).

- Every job container runs in a `podman` container instance based by default on
  `ubuntuImage`. A pipeline job can override this with `image: local/alpine`.

  - Each job containers will have the `/nix/store` mounted from a container
    `nix-daemon-container` (see registration flags
    `--docker-volumes-from "nix-daemon-container:ro"`).

    The `nix-daemon-container` is a single container instance of a
    `nixDaemonImage`. This enables caching of `/nix/store` paths across all jobs
    in all runners. This makes **the host VM's `/nix/store` independent of the
    Nix store used in the jobs**, which is good.

    **Security:** If you don't want this you need multiple `nixDaemonImage`
    containers for each runner.

  - The job containers do **not** mount the `podman` socket from the host (NixOS
    VM) mounted for security reasons.

    **Note:**: One can still build container images with `buildah` (stripped
    `podman` for building images) inside a job which runs `alpineImage`.

### Prerequisites

To make `buildah` (and also `podman`) work inside `local/alpine` and
`local/unbuntu` one needs some `podman` configuration files to place in `/etc`
folders in the container images. Get the files with
`nix run -f ./example/get-podman-config-files.nix` (see
[script](./example/get-podman-config-files.nix)). which will create a `root`
folder which is copied in the example into the images.

:::
