import os

patch_content = """--- a/metadata/water.xml
+++ b/metadata/water.xml
@@ -10,5 +10,21 @@
			<default>&lt;ctrl&gt; &lt;super&gt; BTN_LEFT</default>
		</option>
+		<option name="auto_activate" type="bool">
+			<short>Automatic Water Effect</short>
+			<default>false</default>
+		</option>
+		<option name="continuous" type="bool">
+			<default>false</default>
+		</option>
+		<option name="idle_ripples" type="bool">
+			<default>false</default>
+		</option>
+		<option name="intensity" type="double">
+			<default>0.20</default>
+		</option>
+		<option name="ripple_interval_ms" type="int">
+			<default>3500</default>
+		</option>
	</plugin>
 </wayfire>
--- a/src/water.cpp
+++ b/src/water.cpp
@@ -10,6 +10,8 @@
 #include <wayfire/render-manager.hpp>
 #include <wayfire/view.hpp>
 #include <wayfire/workspace-manager.hpp>
+#include <wayfire/util/log.hpp>
+#include <random>

 static const char *vertex_shader =
     R"(
@@ -165,11 +167,25 @@
     bool hook_set    = false;
     wf::wl_timer<false> timer;
     int points_loc;
+    wf::wl_timer<false> auto_timer;
     std::unique_ptr<wf::input_grab_t> input_grab;
     wf::plugin_activation_data_t grab_interface{
         .name = "water",
         .capabilities = wf::CAPABILITY_MANAGE_COMPOSITOR,
     };

+    wf::option_wrapper_t<bool> auto_activate{"water/auto_activate"};
+    wf::option_wrapper_t<bool> continuous{"water/continuous"};
+    wf::option_wrapper_t<bool> idle_ripples{"water/idle_ripples"};
+    wf::option_wrapper_t<double> intensity{"water/intensity"};
+    wf::option_wrapper_t<int> ripple_interval_ms{"water/ripple_interval_ms"};
+
+    bool is_auto_active = false;
+
   public:
     void init() override
     {
@@ -194,6 +210,50 @@
         output->add_button(button, &activate_binding);

         animation.set(0, 0);
+
+        auto_activate.set_callback([=]() { update_auto_state(); });
+        idle_ripples.set_callback([=]() { update_auto_state(); });
+        update_auto_state();
+    }
+
+    void update_auto_state()
+    {
+        if (auto_activate && idle_ripples)
+        {
+            if (!is_auto_active)
+            {
+                is_auto_active = true;
+                if (!hook_set)
+                {
+                    output->render->add_effect(&damage_hook, wf::OUTPUT_EFFECT_DAMAGE);
+                    output->render->add_post(&render);
+                    hook_set = true;
+                }
+                animation.set(1, 1);
+            }
+
+            auto_timer.set_timeout(ripple_interval_ms, [=]() {
+                if (!is_auto_active) return false;
+
+                auto og = output->get_relative_geometry();
+                std::random_device rd;
+                std::mt19random_engine gen(rd());
+                std::uniform_int_distribution<> x_dist(0, og.width);
+                std::uniform_int_distribution<> y_dist(0, og.height);
+
+                last_cursor = wf::pointf_t{(double)x_dist(gen), (double)y_dist(gen)};
+                button_down = true;
+
+                // Fake a short button press
+                wf::wl_timer<false> *short_timer = new wf::wl_timer<false>();
+                short_timer->set_timeout(100, [=]() {
+                    button_down = false;
+                    delete short_timer;
+                    return false;
+                });
+                return true;
+            });
+        }
+        else
+        {
+            is_auto_active = false;
+            auto_timer.disconnect();
+            if (!button_down && hook_set)
+            {
+                timer.set_timeout(5000, timeout);
+            }
+        }
     }

     void handle_pointer_button(const wlr_pointer_button_event& event) override
@@ -354,7 +414,7 @@
             program[2].deactivate();
         });

-        if (!button_down && !timer.is_connected() && !animation.running())
+        if (!button_down && !timer.is_connected() && !animation.running() && !is_auto_active)
         {
             hook_set = false;
             output->render->rem_effect(&damage_hook);
@@ -370,6 +430,7 @@
         output->rem_binding(&activate_binding);
         input_grab->ungrab_input();
         timer.disconnect();
+        auto_timer.disconnect();
         if (hook_set)
         {
             output->render->rem_effect(&damage_hook);
"""

os.makedirs("euclid-linux-3d/packages/wayfire-plugins-extra", exist_ok=True)
with open("euclid-linux-3d/packages/wayfire-plugins-extra/water-persistent.patch", "w") as f:
    f.write(patch_content)
