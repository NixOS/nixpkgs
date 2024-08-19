import os
import sys

import pytest


@pytest.fixture
def mock_translation_gettext(mocker):
    return mocker.Mock(
        "gettext.translation().gettext",
        # Return the translation key as the translation
        side_effect=lambda t: t,
    )


@pytest.fixture
def mock_gettext_translation(mocker, mock_translation_gettext):
    mock_translation_object = mocker.Mock("gettext.translation()")
    mock_translation_object.gettext = mock_translation_gettext

    return mocker.Mock("gettext.translation", return_value=mock_translation_object)


@pytest.fixture
def globalstorage():
    return {
        "rootMountPoint": "/mnt/root",
        "firmwareType": "efi",
        "partitions": [],
        "keyboardLayout": "us",
        "username": "username",
        "fullname": "fullname",
    }


@pytest.fixture
def mock_check_output(mocker):
    return mocker.Mock(name="subprocess.check_output")


@pytest.fixture
def mock_getoutput(mocker):
    return mocker.Mock(
        name="subprocess.getoutput",
        # subprocess.getoutput() is only called to get the output of `nixos-version` so it is hard-coded here.
        return_value="24.05.20240815.c3d4ac7 (Uakari)",
    )


@pytest.fixture
def mock_Popen(mocker):
    mock_Popen_inst = mocker.Mock("Popen()")
    mock_Popen_inst.stdout = mocker.Mock("Popen().stdout")
    mock_Popen_inst.stdout.readline = mocker.Mock(
        "Popen().stdout.readline",
        # Make Popen print nothing (empty bytes) to stdout
        return_value=b"",
    )
    mock_Popen_inst.wait = mocker.Mock(
        "Popen().wait",
        # Make Popen().wait() give a returncode of 0
        return_value=0,
    )
    return mocker.Mock(name="subprocess.Popen", return_value=mock_Popen_inst)


@pytest.fixture
def mock_libcalamares(mocker, globalstorage):
    mock_libcalamares = mocker.Mock("libcalamares")

    mock_libcalamares.globalstorage = mocker.Mock("libcalamares.globalstorage")
    mock_libcalamares.globalstorage.value = mocker.Mock(
        "libcalamares.globalstorage.value"
    )
    mock_libcalamares.globalstorage.value.side_effect = lambda k: globalstorage.get(k)

    mock_libcalamares.utils = mocker.Mock("libcalamares.utils")
    mock_libcalamares.utils.gettext = mocker.Mock("libcalamares.utils.gettext")
    mock_libcalamares.utils.gettext_path = mocker.Mock(
        "libcalamares.utils.gettext_path"
    )
    mock_libcalamares.utils.gettext_languages = mocker.Mock(
        "libcalamares.utils.gettext_languages"
    )
    mock_libcalamares.utils.warning = mocker.Mock("libcalamares.utils.warning")
    mock_libcalamares.utils.debug = mocker.Mock("libcalamares.utils.debug")
    mock_libcalamares.utils.host_env_process_output = mocker.Mock(
        "libcalamares.utils.host_env_process_output"
    )

    mock_libcalamares.job = mocker.Mock("libcalamares.job")
    mock_libcalamares.job.setprogress = mocker.Mock("libcalamares.job.setprogress")

    return mock_libcalamares


@pytest.fixture
def mock_open_hwconf(mocker):
    return mocker.Mock('open("hardware-configuration.nix")')


@pytest.fixture
def mock_open_kbdmodelmap(mocker):
    return mocker.Mock('open("kbd-model-map")')


@pytest.fixture
def mock_open(mocker, mock_open_hwconf, mock_open_kbdmodelmap):
    testing_dir = os.path.dirname(__file__)

    hwconf_txt = ""
    with open(os.path.join(testing_dir, "hardware-configuration.nix"), "r") as hwconf:
        hwconf_txt = hwconf.read()

    kbdmodelmap_txt = ""
    with open(os.path.join(testing_dir, "kbd-model-map"), "r") as kbdmodelmap:
        kbdmodelmap_txt = kbdmodelmap.read()

    mock_open = mocker.Mock("open")

    def fake_open(*args):
        file, mode, *_ = args

        assert mode == "r", "open() called without the 'r' mode"

        if file.endswith("hardware-configuration.nix"):
            return mocker.mock_open(mock=mock_open_hwconf, read_data=hwconf_txt)(*args)
        elif file.endswith("kbd-model-map"):
            return mocker.mock_open(
                mock=mock_open_kbdmodelmap, read_data=kbdmodelmap_txt
            )(*args)
        else:
            raise AssertionError(f"open() called with unexpected file '{file}'")

    mock_open.side_effect = fake_open

    return mock_open


@pytest.fixture
def run(
    mocker,
    mock_gettext_translation,
    mock_libcalamares,
    mock_check_output,
    mock_getoutput,
    mock_Popen,
    mock_open,
):
    sys.modules["libcalamares"] = mock_libcalamares

    mocker.patch("gettext.translation", mock_gettext_translation)

    mocker.patch("subprocess.check_output", mock_check_output)
    mocker.patch("subprocess.getoutput", mock_getoutput)
    mocker.patch("subprocess.Popen", mock_Popen)

    mocker.patch("builtins.open", mock_open)

    from modules.nixos.main import run

    return run
