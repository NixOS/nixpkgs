from setuptools import setup

setup(
    name="flatten_references_graph",
    version="0.1.0",
    author="Adrian Gierakowski",
    packages=["flatten_references_graph"],
    install_requires=[
        "igraph",
        "toolz"
    ],
    entry_points={
        "console_scripts": [
            "flatten_references_graph=flatten_references_graph.__main__:main"
        ]
    }
)
