from nixos_rebuild import utils as u


def test_dict_to_flags() -> None:
    r = u.dict_to_flags(
        {
            "test_flag_1": True,
            "test_flag_2": False,
            "test_flag_3": "value",
            "test_flag_4": ["v1", "v2"],
            "test_flag_5": None,
            "verbose": 5,
        }
    )
    assert r == [
        "--test-flag-1",
        "--test-flag-3",
        "value",
        "--test-flag-4",
        "v1",
        "v2",
        "-vvvvv",
    ]
