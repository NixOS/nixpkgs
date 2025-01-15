import textwrap

import nixos_rebuild.utils as u


def test_dict_to_flags() -> None:
    assert u.dict_to_flags(None) == []
    r1 = u.dict_to_flags(
        {
            "test_flag_1": True,
            "test_flag_2": False,
            "test_flag_3": "value",
            "test_flag_4": ["v1", "v2"],
            "test_flag_5": [["o1", "v1"], ["o2", "v2"]],
            "test_flag_6": None,
            "t": True,
            "v": 5,
            "quiet": 2,
        }
    )
    assert r1 == [
        "--test-flag-1",
        "--test-flag-3",
        "value",
        "--test-flag-4",
        "v1",
        "--test-flag-4",
        "v2",
        "--test-flag-5",
        "o1",
        "v1",
        "--test-flag-5",
        "o2",
        "v2",
        "-t",
        "-vvvvv",
        "--quiet",
        "--quiet",
    ]
    r2 = u.dict_to_flags({"verbose": 0, "empty_list": []})
    assert r2 == []


def test_remap_dicts() -> None:
    assert u.remap_dicts(
        [{"foo": 1, "bar": True}, {"qux": "keep"}],
        {"foo": "Foo", "bar": "Bar"},
    ) == [{"Foo": 1, "Bar": True}, {"qux": "keep"}]


def test_tabulate() -> None:
    assert u.tabulate([]) == ""
    assert u.tabulate([{}]) == "\n"
    assert u.tabulate(
        [{"foo": 12345, "bar": ["abc", "cde"]}, {"foo": 345, "bar": 456}],
        {"foo": "Foo", "bar": "Bar"},
    ) == textwrap.dedent("""\
        Foo    Bar
        12345  ['abc', 'cde']
        345    456""")
