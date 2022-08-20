# reason for failure: tests try to open display
[
  "test_background_color"
  "test_scene_add_remove"
  "test_Circle"
  "test_wait_skip"
  "test_basic_scene_with_default_values"
  "test_dry_run_with_png_format"
  "test_dry_run_with_png_format_skipped_animations"
  "test_FixedMobjects3D"
  "test_basic_scene_l_flag"
  "test_n_flag"
  "test_s_flag_opengl_renderer"
  "test_s_flag_no_animations"
  "test_image_output_for_static_scene"
  "test_no_image_output_with_interactive_embed"
  "test_no_default_image_output_with_non_static_scene"
  "test_image_output_for_static_scene_with_write_to_movie"
  "test_s_flag"
  "test_r_flag"
  "test_play_skip"
  "test_write_to_movie_disables_window"
  "test_a_flag"
  "test_pixel_coords_to_space_coords"
  "test_t_values"
  "test_custom_folders"
  "test_t_values[15]"
  "test_t_values[30]"
  "test_t_values[60]"
  "test_dash_as_filename"
  "test_images_are_created_when_png_format_set_for_opengl"
  "test_t_values_with_skip_animations"
  "test_static_wait_detection"
  "test_non_static_wait_detection"
  "test_frozen_frame"
  "test_gif_format_output"
  "test_animate_with_changed_custom_attribute"
  "test_images_are_zero_padded_when_zero_pad_set_for_opengl"
  "test_mp4_format_output"
  "test_videos_not_created_when_png_format_set"
  "test_images_are_created_when_png_format_set"
  "test_images_are_zero_padded_when_zero_pad_set"
  "test_webm_format_output"
  "test_default_format_output_for_transparent_flag"
  "test_mov_can_be_set_as_output_format"
  "test_force_window_opengl_render_with_format"
  "test_get_frame_with_preview_disabled"
  "test_get_frame_with_preview_enabled"
] ++

# reason for failure: tests try to reach network
[
  "test_logging_to_file"
  "test_plugin_function_like"
  "test_plugin_no_all"
  "test_plugin_with_all"
] ++

# failing with:
# E           AssertionError:
# E           Not equal to tolerance rtol=1e-07, atol=1.01
# E           Frame no -1. You can use --show_diff to visually show the difference.
# E           Mismatched elements: 18525 / 1639680 (1.13%)
# E           Max absolute difference: 255
# E           Max relative difference: 255.
[
  "test_Text2Color"
] ++

# failing with:
# TypeError: __init__() got an unexpected keyword argument 'msg' - maybe you meant pytest.mark.skipif?
[
  "test_force_window_opengl_render_with_movies"
]
